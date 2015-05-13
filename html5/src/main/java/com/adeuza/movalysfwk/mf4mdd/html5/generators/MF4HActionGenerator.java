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
package com.adeuza.movalysfwk.mf4mdd.html5.generators;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.a2a.adjava.generator.impl.ActionGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.languages.html5.xmodele.MH5ImportDelegate;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAction;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.html5.xmodele.MF4HViewModel;

/**
 * Action generator
 * @author lmichenaud
 *
 */
public class MF4HActionGenerator extends ActionGenerator {

	/**
	 * Package for action
	 */
	public static final String ACTION_PACKAGE = "src";
	
	public static final String VIEW_SOURCEDIR = "webapp/src/app/views/";
	
	@Override
	public void genere(
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		super.genere(p_oProject, p_oGeneratorContext);
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ActionGenerator#createAction(com.a2a.adjava.xmodele.MAction, com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	protected void createAction(MAction p_oAction,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject,
			DomainGeneratorContext p_oGeneratorContext) throws Exception {
		if ( p_oAction.getType().equals(MActionType.SAVEDETAIL) ||
				p_oAction.getType().equals(MActionType.DELETEDETAIL)) {
			super.createAction(p_oAction, p_oMProject, p_oGeneratorContext);
		}
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ActionGenerator#getFilename(com.a2a.adjava.xmodele.MAction, com.a2a.adjava.xmodele.XProject)
	 */
	@Override
	protected String getFilename(MAction p_oAction,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForJS(VIEW_SOURCEDIR + p_oAction.getVm().getUmlName(), p_oAction.getName());
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ActionGenerator#computeXml(com.a2a.adjava.xmodele.MAction, com.a2a.adjava.xmodele.XProject)
	 */
	@Override
	protected Document computeXml(MAction p_oAction,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject) {
		Document r_xDoc = super.computeXml(p_oAction, p_oMProject);
		
		MH5ImportDelegate oImportDlg = new MH5ImportDelegate(this);

		if(p_oAction.getType().equals(MActionType.SAVEDETAIL) && !p_oAction.getVm().isScreenWorkspace()){
			oImportDlg.addImport(p_oAction.getVm().getName()+"Factory");
		}
		if(p_oAction.getDao() !=null){
			oImportDlg.addImport(p_oAction.getDao().getName()+"Proxy");
		}
		
		if (p_oAction.getVm().isScreenWorkspace()) {
			// find data Loader
			oImportDlg.addImport(p_oAction.getParameterValue("WorkspaceLoaderName"));
		} else {
			oImportDlg.addImport(((MF4HViewModel)p_oAction.getVm()).getDataLoader().getName());
		}
		
		r_xDoc.getRootElement().add(oImportDlg.toXml());
		
		Element workspaceNode = DocumentHelper.createElement("workspace");
		workspaceNode.addElement("workspace-screen").setText(String.valueOf(p_oAction.getVm().isScreenWorkspace()));
		if (!p_oAction.getVm().isScreenWorkspace() && p_oAction.getVm().getParent()!=null) {
			workspaceNode.addElement("workspace-detail").setText(String.valueOf(p_oAction.getVm().getParent().isScreenWorkspace()));
		}
		r_xDoc.getRootElement().add(workspaceNode);
		
		return r_xDoc ;
	}
}
