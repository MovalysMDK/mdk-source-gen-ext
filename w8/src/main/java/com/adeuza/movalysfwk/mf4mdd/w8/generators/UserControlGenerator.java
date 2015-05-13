/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.generators;

import java.lang.ref.WeakReference;
import java.util.Map.Entry;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.a2a.adjava.generator.core.incremental.AbstractIncrementalGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.Chrono;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.MAdapter;
import com.a2a.adjava.xmodele.MLayout;
import com.a2a.adjava.xmodele.MDialog;
import com.a2a.adjava.xmodele.MPage;
import com.a2a.adjava.xmodele.MVisualField;
import com.a2a.adjava.xmodele.XProject;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDomain;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelFactory;
import com.adeuza.movalysfwk.mf4mdd.w8.extractor.MF4WScreenDependencyProcessor.MF4WNavigationV2;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WPage;

/**
 * <p>
 * Generate Xaml layout for win 8
 * </p>
 * 
 * <p>
 * Copyright (c) 2011
 * <p>
 * Company: Adeuza
 * 
 * @author xbreysse
 * 
 */

public class UserControlGenerator extends AbstractIncrementalGenerator<MFDomain<MFModelDictionary, MFModelFactory>> {

	/**
	 * Logger
	 */
	private static final Logger log = LoggerFactory.getLogger(UserControlGenerator.class);

	/**
	 * Template for Xaml layout
	 */
	private static final String XAML_USER_CONTROL_TEMPLATE = "xaml-user-control";

	/**
	 * Template for Xaml layout
	 */
	private static final String XAML_DATA_TEMPLATE_TEMPLATE = "xaml-data-template";

	/**
	 * Current template
	 */
	private static String XAML_CURRENT_TEMPLATE;

	@Override
	public void genere(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oGeneratorContext) 
			throws Exception {
		log.debug("> Generate cs layout");
		Chrono oChrono = new Chrono(true);
		for (MLayout oMLayout : p_oMProject.getDomain().getDictionnary().getAllLayouts()) {
			if (isUserControl(oMLayout)) {
				this.CreateXamlLayout(oMLayout, p_oMProject, p_oGeneratorContext);
			}
		}
		for (MDialog oMDialog : p_oMProject.getDomain().getDictionnary().getAllDialogs()) {
			MLayout oMLayout = oMDialog.getLayout();
			if (isUserControl(oMLayout)) {
				this.CreateXamlLayout(oMLayout, p_oMProject, p_oGeneratorContext);
			}
			
		}

		log.debug("< LayoutGenerator.genere: {}", oChrono.stopAndDisplay());
	}

	/**
	 * Create layout xaml
	 * 
	 * @param p_oLayout
	 *            layout
	 * @param p_oMProject
	 *            project
	 * @param p_oContext
	 *            context
	 * @throws Exception
	 */
	protected void CreateXamlLayout(MLayout p_oLayout, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject, DomainGeneratorContext p_oContext) 
			throws Exception {
		String sXamlLayoutFile;
		ComputeVisualFieldPosition(p_oLayout);
		Document xXamlLayout;
		if (p_oLayout.getParameterValue("vmtype") != null && p_oLayout.getParameterValue("parentvmtype") == null) {
			this.setUserControlTemplate(p_oMProject);
			sXamlLayoutFile = this.getXamlFileName("View.Panels", p_oLayout, p_oMProject);
			xXamlLayout = this.computeXmlForXamlUC(p_oLayout, p_oMProject);
		} else {
			this.setDataTemplateTemplate(p_oMProject);
			sXamlLayoutFile = this.getXamlDataTemplateName("View.DataTemplates", p_oLayout, p_oMProject);
			xXamlLayout = this.computeXmlForXamlDataTemplate(p_oLayout, p_oMProject);
		}

		WeakReference<MPage> opage = p_oLayout.getPage();

		if (opage != null) {
			if (opage.get() instanceof MF4WPage) {
				Element xNavs = xXamlLayout.getRootElement().addElement("navigationsV2");
				for (MF4WNavigationV2 oNavigation : ((MF4WPage) opage.get()).getNavigationV2()) {
					xNavs.add(oNavigation.toXml());
				}

				xNavs = xXamlLayout.getRootElement().addElement("reverse-navigationsV2");
				for (MF4WNavigationV2 oNavigation : ((MF4WPage) opage.get()).getReverseNavigationV2()) {
					xNavs.add(oNavigation.toXml());
				}
			}
			if (opage.get().getParent()!= null)
			{
				xXamlLayout.getRootElement().addElement("in-workspace").setText(Boolean.toString(opage.get().getParent().isWorkspace()));
				xXamlLayout.getRootElement().addElement("in-multipanel").setText(Boolean.toString(opage.get().getParent().isMultiPanel()));
			}
		}
		
		// Add search informations to the user control
		if (p_oLayout.getPage() != null && p_oLayout.getPage().get() != null && p_oLayout.getPage().get() instanceof MF4WPage) {
			MLayout oSearchLayout = ((MF4WPage) p_oLayout.getPage().get()).getSearchLayout();
			if (oSearchLayout != null) {
				xXamlLayout.getRootElement().addElement("search-template").setText(oSearchLayout.getPage().get().getFullName());
			}
		}

		log.debug("  generation du fichier {}", sXamlLayoutFile);
		this.doIncrementalTransform(this.getCurrentTemplate(), sXamlLayoutFile, xXamlLayout, p_oMProject, p_oContext);
	}

	/**
	 * Get filename for xaml layout
	 * 
	 * @param p_oLayout
	 *            layout
	 * @param p_oMProject
	 *            project
	 * @return file name for layout
	 */
	protected String getXamlFileName(String directory, MLayout p_oLayout, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForXaml(directory, p_oLayout.getShortName(), p_oMProject.getSourceDir());
	}

	/**
	 * Get filename for xaml layout
	 * 
	 * @param p_oLayout
	 *            layout
	 * @param p_oMProject
	 *            project
	 * @return file name for layout
	 */
	protected String getXamlDataTemplateName(String directory, MLayout p_oLayout, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForXaml(directory, p_oLayout.getFullName(), p_oMProject.getSourceDir());
	}

	/**
	 * Compute xml node of the xaml layout
	 * 
	 * @param p_oDataLoader
	 *            layout
	 * @return xml
	 */
	protected Document computeXmlForXamlUC(MLayout p_oLayout, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		Element r_xFile = p_oLayout.toXml();
		r_xFile.addElement("master-package").setText(p_oMProject.getDomain().getRootPackage());

		if (p_oLayout.getAdapter() != null) {
			Element adapter = p_oLayout.getAdapter().get().toXml();
			r_xFile.add(adapter);
		} else {
			if (p_oLayout.getPage() != null && p_oLayout.getPage().get().getAdapter() != null) {
				Element adapter = p_oLayout.getPage().get().getAdapter().toXml();
				r_xFile.add(adapter);
			}
		}

		Element externalAdapters = r_xFile.addElement("ExternalAdapters");
		if (p_oLayout.getExternalAdapters() != null && p_oLayout.getExternalAdapters().size() > 0) {
			for (WeakReference<MAdapter> oMAdatperMap : p_oLayout.getExternalAdapters()) {
				Element externalAdapter = oMAdatperMap.get().toXml();
				externalAdapters.add(externalAdapter);
			}
		} else {
			if (p_oLayout.getPage() != null && p_oLayout.getPage().get().getExternalAdapters() != null) {
				for (Entry<String, MAdapter> oMAdatperMap : p_oLayout.getPage().get().getExternalAdapters().entrySet()) {
					Element externalAdapter = oMAdatperMap.getValue().toXml();
					externalAdapters.add(externalAdapter);
				}
			}
		}

		if (p_oLayout.getPage() != null) {
			r_xFile.addElement("package").setText(p_oLayout.getPage().get().getPackage().getFullName());
		}
		Document xXamlLayout = DocumentHelper.createDocument(r_xFile);
		return xXamlLayout;
	}

	protected Document computeXmlForXamlDataTemplate(MLayout p_oLayout, XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		Element r_xFile = p_oLayout.toXml();
		r_xFile.addElement("master-package").setText(p_oMProject.getDomain().getRootPackage());
		Element externalAdapters = r_xFile.addElement("ExternalAdapters");

		if (p_oLayout.getAdapter() != null
				&& p_oLayout.getParameterValue("vmtype") != null
				&& p_oLayout.getParameterValue("vmtype").equalsIgnoreCase(ViewModelType.LISTITEM_2.toString())) {
			Element adapter = p_oLayout.getAdapter().get().toXml();
			r_xFile.add(adapter);
		}

		if (p_oLayout.getExternalAdapters() != null) {
			for (WeakReference<MAdapter> oMAdatperMap : p_oLayout.getExternalAdapters()) {
				for (MVisualField vf : p_oLayout.getFields()) {
					if (vf.getParameterValue("combo") != null && vf.getParameterValue("combo").equalsIgnoreCase("true")) {
						if (vf.getViewModelProperty().equals(oMAdatperMap.get().getViewModel().getMasterInterface().getName())) {
							Element externalAdapter = oMAdatperMap.get().toXml();
							externalAdapters.add(externalAdapter);
							break;
						}
					}
				}
			}
		}

		Document xXamlLayout = DocumentHelper.createDocument(r_xFile);
		return xXamlLayout;
	}

	protected static boolean isUserControl(MLayout p_oLayout) {
		return (p_oLayout.getScreen() == null || (!p_oLayout.getScreen().get().isMultiPanel()
				&& !p_oLayout.getScreen().get().isWorkspace() 
				&& p_oLayout.getScreen().get().getPageCount() > 0));
	}

	/**
	 * Get template for xaml layout
	 * 
	 * @return template for xaml layout
	 */
	protected void setDataTemplateTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		XAML_CURRENT_TEMPLATE = XAML_DATA_TEMPLATE_TEMPLATE + ".xsl";
	}

	/**
	 * Get template for xaml screen
	 * 
	 * @return template for xaml screen
	 */
	protected void setUserControlTemplate(XProject<MFDomain<MFModelDictionary, MFModelFactory>> p_oMProject) {
		XAML_CURRENT_TEMPLATE = XAML_USER_CONTROL_TEMPLATE + ".xsl";
	}

	/**
	 * Get current template
	 * 
	 * @return current template
	 */
	protected String getCurrentTemplate() {
		return XAML_CURRENT_TEMPLATE;
	}

	protected void ComputeVisualFieldPosition(MLayout p_oLayout) {
		int count = 1;
		for (MVisualField visualField : p_oLayout.getFields()) {
			if (visualField.isCreateLabel()) {
				visualField.setLabelPosition(Integer.toString(count));
				count += 1;
			}
			visualField.setComponentPosition(Integer.toString(count));
			count += 1;
		}
	}
}