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
package com.adeuza.movalysfwk.mf4mdd.ios.generators;

import org.dom4j.Document;

import com.a2a.adjava.generator.impl.ActionInterfaceGenerator;
import com.a2a.adjava.generators.DomainGeneratorContext;
import com.a2a.adjava.utils.FileTypeUtils;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MActionInterface;
import com.a2a.adjava.xmodele.MActionType;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.ios.xmodele.MF4IImportDelegate;

/**
 * Generator for interface of action
 * 
 * @author lmichenaud
 * 
 */
public class MF4IActionInterfaceGenerator extends ActionInterfaceGenerator {

	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.generator.impl.ActionInterfaceGenerator#createAction(com.a2a.adjava.xmodele.MActionInterface, com.a2a.adjava.xmodele.XProject, com.a2a.adjava.generators.DomainGeneratorContext)
	 */
	@Override
	protected void createAction(MActionInterface p_oAction,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject,
			DomainGeneratorContext p_oContext) throws Exception {
		if (p_oAction.getActionType().equals(MActionType.SAVEDETAIL)
				|| p_oAction.getActionType().equals(MActionType.DELETEDETAIL)) {
			super.createAction(p_oAction, p_oMProject, p_oContext);
		}
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.generator.impl.ActionInterfaceGenerator#computeXml(com.a2a.adjava.xmodele.MActionInterface)
	 */
	@Override
	protected Document computeXml(MActionInterface p_oAction, XProject<IDomain<IModelDictionary,IModelFactory>> p_oMProject) {
		Document r_xDoc = super.computeXml(p_oAction, p_oMProject);

		MF4IImportDelegate oImportDlg = new MF4IImportDelegate(this);
		r_xDoc.getRootElement().add(oImportDlg.toXml());

		return r_xDoc;
	}

	/**
	 * {@inheritDoc}
	 * 
	 * @see com.a2a.adjava.generator.impl.ActionGenerator#getFilename(com.a2a.adjava.xmodele.MAction,
	 *      com.a2a.adjava.xmodele.XProject)
	 */
	@Override
	protected String getFilename(MActionInterface p_oAction,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject) {
		return FileTypeUtils.computeFilenameForIOSInterface(
				MF4IActionImplGenerator.ACTION_PACKAGE, p_oAction.getName(),
				p_oMProject.getSourceDir());
	}
}
